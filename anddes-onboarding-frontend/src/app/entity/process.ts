import { Activity } from "./activity";
import { UserData } from "./user";

export class Process {
    id: number;
    user: UserData;
    startDate: Date;
    status : number;
    hourOnsite : string
    placeOnsite : string
    hourRemote : string
    linkRemote : string
    results : string[];
}

export class ProcessAdd{
    userId : number
    startDate : Date
    hourOnsite : string
    placeOnsite : string
    hourRemote : string
    linkRemote : string
}

export class ProcessActivity{
    id : number;
    activity : Activity;
    completed:boolean;
    completionDate : boolean;
}

export class Indicator{
  totalProcesses : number = 0;
  completedProcesses : number = 0;
  delayedProcesses : number = 0;

  completedELearning : number = 20;
  averageELearningCompleted : number = 40;
}