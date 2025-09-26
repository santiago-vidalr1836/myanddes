import { Location } from '@angular/common';
import { ChangeDetectorRef, Component, OnInit } from '@angular/core';
import { MatIconModule } from '@angular/material/icon';
import { Router } from '@angular/router';
import { ELearningContent, ELearningContentCard, ELearningContentCardOption } from '../../entity/activity';
import { Constants } from '../../entity/constants';
import { MatButtonModule } from '@angular/material/button';
import { MatMenuModule } from '@angular/material/menu';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { HtmlEditorComponent } from '../html-editor/html-editor.component';
import { ActivityService } from '../../service/activity.service';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { MatDialog } from '@angular/material/dialog';
import { OptionEditDialog } from './option-edit-dialog/option.edit.dialog';
import { MatInputModule } from '@angular/material/input';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { MatTooltipModule } from '@angular/material/tooltip';
import { SnackbarService } from '../../service/snackbar.service';
import { FileService } from '../../service/file.service';
import { UtilService } from '../../service/util.service';

@Component({
  selector: 'app-elearning-content-edit',
  standalone: true,
  imports: [MatIconModule,
            MatButtonModule,
            MatMenuModule,
            MatFormFieldModule,
            MatInputModule,
            FormsModule,
            ReactiveFormsModule,
            HtmlEditorComponent,
            MatTableModule,
            MatSlideToggleModule,
            MatTooltipModule,
            MatProgressSpinnerModule
  ],
  templateUrl: './elearning-content-edit.component.html',
  styleUrl: './elearning-content-edit.component.scss'
})
export class ElearningContentEditComponent implements OnInit{
  content : ELearningContent 
  TYPE_QUESTION = Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION
  TYPE_TEXT = Constants.ELEARNING_CONTENT_CARD_TYPE_TEXT
  TYPE_VIDEO = Constants.ELEARNING_CONTENT_CARD_TYPE_VIDEO
  defaultTextOption="Edita la opción respuesta"
  displayedColumns= ["correct","name","action"];

  constructor(private location : Location,
              private router : Router,
              private activityService : ActivityService,
              public dialog: MatDialog,
              private changeDetectorRefs: ChangeDetectorRef,
              private snackBarService : SnackbarService,
              private cdr: ChangeDetectorRef,
              private fileService : FileService,
              public utilService : UtilService
  ){}

  ngOnInit(): void {
    if(typeof window !== 'undefined'){
      this.content=window.history.state
    }
  }
  back(){
    this.location.back()
  }
  moveUpCard(card: ELearningContentCard,$index:number) {
    if($index>0){
      let cardToMove = this.content.cards[$index-1];
      let tempOrder = card.position;
      card.position = cardToMove.position;
      cardToMove.position = tempOrder;

      this.content.cards[$index]=cardToMove;
      this.content.cards[$index-1]=card;  
    }
  }
  moveDownCard(card: ELearningContentCard,$index:number) {
    if($index!=this.content.cards.length-1){
      let cardToMove=this.content.cards[$index+1];
      let tempPosition=card.position;
      card.position=cardToMove.position;
      cardToMove.position=tempPosition;

      this.content.cards[$index]=cardToMove;
      this.content.cards[$index+1]=card;
    }
  }

  addText(){
    if(this.content.cards==undefined)this.content.cards=[]
    var card = new ELearningContentCard();
    card.position = this.content.cards.length
    card.type = Constants.ELEARNING_CONTENT_CARD_TYPE_TEXT
    this.content.cards.push(card)
  }
  addQuestion(){
    if(this.content.cards==undefined)this.content.cards=[]
    var card = new ELearningContentCard();
    card.position = this.content.cards.length
    card.type = Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION
    card.options=[];
    /*card.options = [{
      id : null,
      description : this.defaultTextOption,
      deleted : false,
      correct : false
    }]*/
    this.content.cards.push(card)
  }
  addVideo(){
    if(this.content.cards==undefined)this.content.cards=[]
    var card = new ELearningContentCard();
    card.position = this.content.cards.length
    card.type = Constants.ELEARNING_CONTENT_CARD_TYPE_VIDEO
    this.content.cards.push(card)
  }
  
  setOptionCorrect(card:ELearningContentCard,option: ELearningContentCardOption) {
    card.options.forEach(o=>o.correct=false)
    option.correct=true
  }
  updateOption(option: ELearningContentCardOption,i : number){
    const dialogRef = this.dialog.open(OptionEditDialog,{data : option.description});
    dialogRef.afterClosed().subscribe((result:string)=>{
      if(result && result.length>0)
        option.description=result
    });   
  }
  addOption(card:ELearningContentCard){
    if(card.options && card.options.length>0 && card.options.filter(o=>o.description==='').length>0){
      return;
    }
    if(card.options==undefined) card.options=[]
    var option = new ELearningContentCardOption()
    option.description=''
    option.deleted = false
    option.correct = false
    card.options.push(option)
    this.changeDetectorRefs.detectChanges()
  }
  
  getDataSource(card: ELearningContentCard){
    return new MatTableDataSource(card.options.filter(o=>!o.deleted))
  }
  save(){
    var messageErroValidation =  this.getErrorValidation()
    if(messageErroValidation.length>0){
      this.snackBarService.error(messageErroValidation)
      return
    }
    this.activityService.updateELearningContent(Constants.ACTIVITY_INDUCTION_ELEARNING,this.content).subscribe(()=>{
      this.snackBarService.success('Contenido actualizado')
      this.router.navigate(["first-week"])
    })
  }
  getErrorValidation(): string{
    var messageErroValidation=''
    if(this.content.cards.filter(c=>!c.title && !c.deleted && !c.content &&  c.type==Constants.ELEARNING_CONTENT_CARD_TYPE_TEXT).length>0){
      messageErroValidation = 'Complete la información de título y contenido para las tarjetas de tipo contenido'
    }
    if(this.content.cards.filter(c=> !c.content && !c.deleted &&   c.type==Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION).length>0){
      messageErroValidation = 'Complete la información de pregunta para las tarjetas de tipo pregunta'
    }
    if(this.content.cards.filter(c=>c.type==Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION && !c.deleted && c.options.filter(o=>!o.description).length>0).length > 0){
      messageErroValidation = 'Complete la descripción de las opciones  para las tarjetas de tipo pregunta'
    }
    if(this.content.cards.filter(c=>c.type==Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION && !c.deleted && c.options.filter(o=>o.correct).length==0).length > 0){
      messageErroValidation = 'Las tarjetas de tipo pregunta deben tener al menos una opción de tipo correcto'
    }
    return messageErroValidation
  }
  acceptedVideo = 'video/mp4'
  acceptedImage = 'image/*'
  
  currentIndex=-1
  currentType=''
  onVideoSelected(event,card,index){
    card.urlVideo=null
    this.currentIndex=index
    this.currentType='video'
    this.cdr.detectChanges();
    if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files.length) {
      const file = (event.target as HTMLInputElement).files[0];
      this.fileService.upload(file).subscribe((r:any)=>{
        card.urlVideo=r.url
        this.currentIndex=-1
        this.currentType=''
      });
      (event.target as HTMLInputElement).value=null
      //this.isLoadingResults = false
      this.cdr.detectChanges();
    }
  }
  onPosterSelected(event,card,index){
    card.urlPoster=null
    this.currentIndex=index
    this.currentType='poster'
    //this.isLoadingResults = true 
    this.cdr.detectChanges();
    if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files.length) {
      const file = (event.target as HTMLInputElement).files[0];
      this.fileService.upload(file).subscribe((r:any)=>{
        card.urlPoster=r.url
        this.currentIndex=-1
        this.currentType=''
      });
      (event.target as HTMLInputElement).value=null
      //this.isLoadingResults = false
      this.cdr.detectChanges();
    }
  }
}
