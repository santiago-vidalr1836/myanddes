export class Service {
    id: number;
    name: string;
    icon: string;
    iconWeb: string;
    description : string;
    details : ServiceDetail[]
}
export class ServiceDetail {
    id: number;
    title: string;
    description : string;
    hidden : boolean;
}