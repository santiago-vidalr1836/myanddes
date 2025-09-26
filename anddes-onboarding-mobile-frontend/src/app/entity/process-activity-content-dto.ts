import { ProcessActivityContent } from "./process-activity-content";

export interface ProcessActivityContentDTO {
    userId : number;
    processId : number;
    processActivityId : number;
    processActivityContent :ProcessActivityContent;
}
