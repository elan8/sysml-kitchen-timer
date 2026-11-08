/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package PowerSystem {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Elan8::Core::*;
    private import Elan8::Electronics::Core::*;
    private import Elan8::Electronics::Components::*;
    private import Elan8::Electronics::Interconnection::*;
    private import Elan8::Procurement::*;
    private import Elan8::Units::Engineering::*;
    private import Elan8::Units::Money::*;
    private import Elan8::PhysicalModeling::*;
    private import KitchenTimerLibrary::milliampere;

    part def TimerCoinCell :> ElectronicsComponent, CostedPart {
        doc /*
         * Replaceable CR2032 primary cell. This is not a rechargeable
         * BatteryPack: nothing in the timer charges it. The 6 mA pulse limit
         * is a short-pulse assumption used only for the alarm-current check.
         * Usable capacity is 80 percent of nominal, an assumption for
         * end-of-life and cutoff, not a measured discharge.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "CR2032";
            url = "";
        }
        attribute nominalMilliampereHours : Real = 220.0;
        attribute usableCapacityFactor : Real = 0.80;
        attribute usableMilliampereHours : Real = nominalMilliampereHours * usableCapacityFactor;
        attribute nominalCapacity : ElectricChargeValue = nominalMilliampereHours * 1 [mAh];
        attribute usableCapacity : ElectricChargeValue = usableMilliampereHours * 1 [mAh];
        attribute nominalVoltage : ElectricPotentialValue = 3.0 [V];
        attribute pulseCurrentLimit : ElectricCurrentValue = 6 [mA];
        attribute cellThickness : LengthValue = 3.2 [mm];
        attribute :>> mass = 0.003 [kg];
        attribute :>> unitCost = 0.35 [EUR];
        port terminal : PowerRailPort;
        port positive : ElectricalTerminalPort;
        port negative : ElectricalTerminalPort;
        @ModelicaModel {
            resourceUri = "modelica://Modelica";
            className = "Modelica.Electrical.Batteries.BatteryStacks.Cell";
        }
    }

    part def TimerReservoirCapacitor :> TantalumCapacitor, CostedPart {
        doc /*
         * Across the cell. It supplies the piezo's high-frequency pulses so
         * the alarm-mode current of 3 mA is the current asked of the cell.
         * A 100 µF capacitor cannot source that 3 mA for the whole alarm.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "C-100UF-6V3";
            url = "";
        }
        attribute :>> capacitance = 0.0001 [F];
        attribute :>> tolerance = new ComponentTolerance(0.2);
        attribute :>> ratedVoltage = 6.3 [V];
        attribute :>> packageType = new ComponentPackage("case A");
        attribute :>> mass = 0.0002 [kg];
        attribute :>> unitCost = 0.04 [EUR];
        @ModelicaModel {
            resourceUri = "modelica://Modelica";
            className = "Modelica.Electrical.Analog.Basic.Capacitor";
        }
    }

    part def PowerSpecification :> PhysicalComponent, Elan8::SystemsEngineering::SystemSpecification {
        port supply : PowerRailPort;
        attribute nominalVoltage : ElectricPotentialValue;
        attribute usableCapacity : ElectricChargeValue;
        attribute usableMilliampereHours : Real;
        attribute pulseCurrentLimit : ElectricCurrentValue;
        attribute cellThickness : LengthValue;
        attribute componentCost : MonetaryAmount;
    }

    part def PowerArchitecture
            :> PowerSpecification, Elan8::SystemsEngineering::SystemArchitecture {
        part cell : TimerCoinCell;
        part reservoir : TimerReservoirCapacitor;
        bind supply = cell.terminal;
        interface reservoirAcrossCellPositive : ElectricalTerminalLink
            connect terminalA ::> cell.positive to terminalB ::> reservoir.positive;
        interface reservoirAcrossCellNegative : ElectricalTerminalLink
            connect terminalA ::> cell.negative to terminalB ::> reservoir.negative;
        attribute :>> nominalVoltage = cell.nominalVoltage;
        attribute :>> usableCapacity = cell.usableCapacity;
        attribute :>> usableMilliampereHours = cell.usableMilliampereHours;
        attribute :>> pulseCurrentLimit = cell.pulseCurrentLimit;
        attribute :>> cellThickness = cell.cellThickness;
        attribute :>> mass = cell.mass + reservoir.mass;
        attribute :>> componentCost = cell.unitCost + reservoir.unitCost;
        doc /*
         * Direct cell rail. A series regulator is omitted because its
         * quiescent current would dominate a two-year coin-cell budget.
         */
    }

    package Views {
        view specification : Elan8::SystemsEngineering::SpecificationView {
            expose PowerSystem::PowerSpecification;
        }
        view architecture : Elan8::SystemsEngineering::ArchitectureView {
            expose PowerSystem::PowerArchitecture;
        }
    }
}
