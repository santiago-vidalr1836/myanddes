import { Activity } from "./activity";

export interface ProcessActivity {
    id : number;
    activity : Activity;
    completed : boolean;
    completionDate : Date;
}