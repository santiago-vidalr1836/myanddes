import { ProcessActivity } from "./process-activity";

export interface ProcessActivityGroup {
    name : string;
    order : number;
    processActivities : ProcessActivity[];
    color : string;
    colorBackground : string;
}
