export interface Service {
    id : number;
    name : string;
    description :string;
    icon : string;
    iconWeb : string;
    position: number;
    details : ServiceDetail[];
}
export interface ServiceDetail{
    id : number;
    title : string;
    description : string;
    hidden : boolean;
    icon : string;
}
