export class UserData {
    id: number;
    fullname: string;
    image : string;
    roles: string[];
    job : string;
    boss: UserData;
    email:string;
}