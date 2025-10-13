export interface ElearningContent {
    id : number;
    name : string;
    image : string;
    cards : ELearningContentCard[];
    passingScore: number;
    position : number;
}
export interface ELearningContentCard{
    id : number;
    title : string;
    type : string;
    draft : boolean;
    content : string;
    deleted : boolean;
    position : number;
    options : ELearningContentCardOption[];
    urlVideo : string;
    urlPoster : string;
}

export interface ELearningContentCardOption{
    id : number;
    description : string;
    correct : boolean;
    deleted : boolean;
}
