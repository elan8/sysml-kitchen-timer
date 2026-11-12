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
         * Panasonic CR2032 primary cell, from
         * input/datasheets/CR2032_Datasheet_EN.pdf (February 2026):
         * nominal 3 V, 225 mAh, continuous drain 0.2 mA, diameter 20.0 mm,
         * height 3.2 mm, approximate mass 2.8 g without tabs.
         * That sheet does not state an internal resistance. Until a measured
         * value or a datasheet figure replaces it, internalResistance is an
         * assumption of 20 ohm, authored here and not a default of the
         * Modelica model. The simulation uses that 20 ohm as Ri.
         * usableCapacity is an mAh expression. The Modelica charge Q0 is
         * nominalMilliampereHours * usableCapacityFactor, converted as
         * 1 mAh = 3.6 C.
         * This is not a rechargeable BatteryPack: nothing in the timer
         * charges it. The 6 mA pulse limit is a short-pulse assumption used
         * only for the alarm-current check; the datasheet does not state it.
         * Usable capacity is 80 percent of the datasheet nominal, an
         * assumption for end-of-life and cutoff, not a measured discharge.
         */
        @BuyPart {
            manufacturer = "Panasonic Energy";
            manufacturerPartNumber = "CR2032";
            url = "";
        }
        attribute nominalMilliampereHours : Real = 225.0 {
            @ExternalVariable {
                variableName = "nominalMilliampereHours";
            }
        }
        attribute usableCapacityFactor : Real = 0.80 {
            @ExternalVariable {
                variableName = "usableCapacityFactor";
            }
        }
        attribute usableMilliampereHours : Real = nominalMilliampereHours * usableCapacityFactor;
        attribute nominalCapacity : ElectricChargeValue = nominalMilliampereHours * 1 [mAh];
        attribute usableCapacity : ElectricChargeValue = usableMilliampereHours * 1 [mAh];
        attribute nominalVoltage : ElectricPotentialValue = 3.0 [V] {
            @ExternalVariable {
                variableName = "V0";
            }
        }
        attribute internalResistance : ResistanceValue = 20 [ohm] {
            @ExternalVariable {
                variableName = "Ri";
            }
        }
        attribute continuousDrain : ElectricCurrentValue = 0.2 [mA];
        attribute pulseCurrentLimit : ElectricCurrentValue = 6 [mA];
        attribute diameter : LengthValue = 20.0 [mm];
        attribute cellThickness : LengthValue = 3.2 [mm];
        attribute :>> mass = 0.0028 [kg];
        attribute :>> unitCost = 0.35 [EUR];
        port terminal : PowerRailPort;
        port positive : ElectricalTerminalPort;
        port negative : ElectricalTerminalPort;
        @ModelicaModel {
            resourceUri = "modelica://Elan8";
            className = "Elan8.KitchenTimer.Cell";
        }
    }

    part def TimerReservoirCapacitor :> TantalumCapacitor, CostedPart {
        doc /*
         * Across the cell. It supplies the piezo's high-frequency pulses so
         * the alarm-mode current of 3 mA is the current asked of the cell.
         * A 100 µF capacitor cannot source that 3 mA for the whole alarm.
         * The Modelica binding is the one on Capacitor,
         * Elan8Electronics.Capacitor. capacitance is that model's parameter.
         * positive and negative are terminal1 and terminal2 there.
         */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "C-100UF-6V3";
            url = "";
        }
        attribute :>> capacitance = 0.0001 [F] {
            @ExternalVariable {
                variableName = "capacitance";
            }
        }
        attribute :>> tolerance = new ComponentTolerance(0.2);
        attribute :>> ratedVoltage = 6.3 [V];
        attribute :>> packageType = new ComponentPackage("case A");
        attribute :>> mass = 0.0002 [kg];
        attribute :>> unitCost = 0.04 [EUR];
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
