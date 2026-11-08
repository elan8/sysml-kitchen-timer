/* SPDX-FileCopyrightText: 2026 Elan8
 * SPDX-License-Identifier: MIT */
package MechanicalAssemblySystem {
    private import ScalarValues::*;
    private import ISQ::*;
    private import SI::*;
    private import Elan8::Mechanical::Core::*;
    private import Elan8::Procurement::*;
    private import Elan8::Units::Money::*;

    part def TimerEnclosure :> MechanicalComponent, CostedPart {
        doc /*
         * One-piece molded body. Outer envelope is the product envelope.
         * Button centers are measured from the left and bottom outer edges.
         */
        @MakePart;
        attribute width : LengthValue = 72 [mm];
        attribute depth : LengthValue = 60 [mm];
        attribute height : LengthValue = 18 [mm];
        attribute wallAllowance : LengthValue = 4 [mm];
        attribute displayApertureWidth : LengthValue = 42 [mm];
        attribute displayApertureHeight : LengthValue = 20 [mm];
        attribute incrementButtonX : LengthValue = 14 [mm];
        attribute decrementButtonX : LengthValue = 28 [mm];
        attribute startStopButtonX : LengthValue = 44 [mm];
        attribute cancelButtonX : LengthValue = 58 [mm];
        attribute buttonRowY : LengthValue = 16 [mm];
        attribute :>> mass = 0.016 [kg];
        attribute :>> unitCost = 0.90 [EUR];
    }

    part def BatteryDoor :> MechanicalComponent, CostedPart {
        doc /* Cover over the cell. The cell itself stays in the power system. */
        @MakePart;
        attribute :>> mass = 0.002 [kg];
        attribute :>> unitCost = 0.12 [EUR];
    }

    part def CellHolder :> MechanicalComponent, CostedPart {
        doc /* Contacts and pocket. No tool is required to remove the cell. */
        @BuyPart {
            manufacturer = "illustrative";
            manufacturerPartNumber = "HOLDER-CR2032";
            url = "";
        }
        attribute :>> mass = 0.001 [kg];
        attribute :>> unitCost = 0.18 [EUR];
    }

    part def MechanicalAssemblySpecification
            :> MechanicalComponent, Elan8::SystemsEngineering::SystemSpecification {
        attribute width : LengthValue;
        attribute depth : LengthValue;
        attribute height : LengthValue;
        attribute wallAllowance : LengthValue;
        attribute displayApertureWidth : LengthValue;
        attribute displayApertureHeight : LengthValue;
        attribute batteryReplaceableWithoutTools : Boolean;
        attribute componentCost : MonetaryAmount;
    }

    part def MechanicalAssemblyArchitecture
            :> MechanicalAssemblySpecification, Elan8::SystemsEngineering::SystemArchitecture {
        part enclosure : TimerEnclosure;
        part batteryDoor : BatteryDoor;
        part cellHolder : CellHolder;
        attribute :>> width = enclosure.width;
        attribute :>> depth = enclosure.depth;
        attribute :>> height = enclosure.height;
        attribute :>> wallAllowance = enclosure.wallAllowance;
        attribute :>> displayApertureWidth = enclosure.displayApertureWidth;
        attribute :>> displayApertureHeight = enclosure.displayApertureHeight;
        attribute :>> batteryReplaceableWithoutTools = true;
        attribute :>> mass = enclosure.mass + batteryDoor.mass + cellHolder.mass;
        attribute :>> componentCost =
            enclosure.unitCost + batteryDoor.unitCost + cellHolder.unitCost;
    }

    package Views {
        view specification : Elan8::SystemsEngineering::SpecificationView {
            expose MechanicalAssemblySystem::MechanicalAssemblySpecification;
        }
        view architecture : Elan8::SystemsEngineering::ArchitectureView {
            expose MechanicalAssemblySystem::MechanicalAssemblyArchitecture;
        }
    }
}
