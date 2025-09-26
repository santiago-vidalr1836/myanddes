export class Activity{
    id : number;
    code : string;
    name : string;
    parent : string;
    parentCode : string;
    editableInWeb : boolean;
    mandatory : boolean;
    manual : boolean;
}

export class CEOPresentation{
    id : number;
    urlVideo : string;
    urlPoster : string;
}

export class FirstDayInformationItem{
    id : number;
    title : string;
    description : string;
    body : string;  
    addFromServices : boolean;
    type : string;
}

export class OnSiteInduction{
    id : number;
    description : string;
}

export class RemoteInduction{
    id : number;
    description : string;
}

export class ELearningContent{
    id : number;
    name : string;
    image : string;
    cards : ELearningContentCard[]
}

export class ELearningContentCard{
    id : number;
    title : string;
    type : string;
    draft : boolean;
    content : string;
    deleted : boolean;
    position : number;
    urlVideo : string;
    urlPoster: string;
    options : ELearningContentCardOption[]
}

export class ELearningContentCardOption{
    id : number;
    description : string;
    correct : boolean;
    deleted : boolean;
}