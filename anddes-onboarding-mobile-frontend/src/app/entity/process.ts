export interface Process {
    id : number;
    startDate : Date;
    status : number;
    results : string[];
    finished : boolean;
    delayed: boolean;
    welcomed: boolean;
    hourOnsite : string;
    placeOnsite : string;
    hourRemote : string;
    linkRemote : string;
}
