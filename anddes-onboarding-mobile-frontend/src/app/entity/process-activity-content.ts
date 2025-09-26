import { ELearningContentCard, ELearningContentCardOption , ElearningContent } from "./elearning-content";

export interface ProcessActivityContent {
    id : number;
    content : ElearningContent;
    result : number;
    progress : number;
    cards : ProcessActivityContentCard[];
}
export interface ProcessActivityContentCard{
    id : number;
    card : ELearningContentCard;
    answer : ELearningContentCardOption;
    readDateMobile : Date;
    readDateServer : Date;
    points : number;
}

export interface ProcessActivityContentResult{
    result : number;
}
