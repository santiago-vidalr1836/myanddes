import { Component, inject, Inject } from '@angular/core';
import { MAT_BOTTOM_SHEET_DATA, MatBottomSheetRef } from '@angular/material/bottom-sheet';
import { ProcessActivityContentDTO } from '../../entity/process-activity-content-dto';
import { ELearningContentCard, ELearningContentCardOption } from '../../entity/elearning-content';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatButtonModule } from '@angular/material/button';
import { Constants } from '../../entity/constants';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { CommonModule } from '@angular/common';
import { MatIconModule } from '@angular/material/icon';
import { SafeHtmlPipe } from "../../pipe/safe-html.pipe";
import { MatRadioModule } from '@angular/material/radio';
import { FormsModule } from '@angular/forms';
import { OnboardingService } from '../../service/onboarding.service';
import { ProcessActivityContentCard } from '../../entity/process-activity-content';
import { SnackbarService } from '../../service/snackbar.service';
@Component({
  selector: 'app-elearning-content-card',
  imports: [MatProgressBarModule, MatButtonModule, MatProgressSpinnerModule, 
            CommonModule, MatIconModule, SafeHtmlPipe,MatRadioModule,CommonModule,FormsModule],
  templateUrl: './elearning-content-card.component.html',
  styleUrl: './elearning-content-card.component.scss'
})
export class ElearningContentCardComponent {
  answer = {} as ELearningContentCardOption;
  ELEARNING_CONTENT_CARD_TYPE_QUESTION=Constants.ELEARNING_CONTENT_CARD_TYPE_QUESTION;
  ELEARNING_CONTENT_CARD_TYPE_TEXT=Constants.ELEARNING_CONTENT_CARD_TYPE_TEXT;
  ELEARNING_CONTENT_CARD_TYPE_VIDEO=Constants.ELEARNING_CONTENT_CARD_TYPE_VIDEO;
  showResult = false;
  dto = {} as ProcessActivityContentDTO;
  currentCard: ProcessActivityContentCard | null= null;
  currentIndex : number=1;
  processActivityContentFinished=false;
  canGoToNextCard = false;
  private _bottomSheetRef = inject<MatBottomSheetRef<ElearningContentCardComponent>>(MatBottomSheetRef);
  constructor(@Inject(MAT_BOTTOM_SHEET_DATA) public data:ProcessActivityContentDTO,
             private onboardingService : OnboardingService,
            private snackbarService : SnackbarService,
            ){
    //if(data.body)
    //  data.body=data.body.replaceAll("<img","<img width=\'100%\'");
    this.dto = data;
    
    if(this.dto.processActivityContent.result){
      this.processActivityContentFinished = true;
      this.currentCard = this.dto.processActivityContent.cards[0];
      this.currentIndex=1;
      this.canGoToNextCard = true;
    }else{
      this.canGoToNextCard = false;
      var cardsUnreaded=this.dto.processActivityContent.cards.filter(pac=>!pac.readDateMobile);
      if(cardsUnreaded.length>0){
        this.currentCard = cardsUnreaded[0];
        setTimeout(()=>{
          this.canGoToNextCard= this.currentCard!.card.type!=Constants.ELEARNING_CONTENT_CARD_TYPE_VIDEO;
          this.canGoToNextCard = true;
        },2*1000)
        this.currentIndex= this.dto.processActivityContent.cards.findIndex(card=>card==cardsUnreaded[0])+1;
      }else {
        this.getResult();
      }
    }
  }
  onVideoEnded(){
    this.canGoToNextCard = true;
  }
  nextCard(){
    if(!this.currentCard!.readDateMobile){
      var currentId=this.currentCard!.id;
      this.currentCard = null;
      var answer={
        'readDateMobile' : new Date(),
        answer : this.answer
      }
      this.onboardingService.updateReadAndAnswer(this.dto.userId,
                                                  this.dto.processId,
                                                  this.dto.processActivityId,
                                                  this.dto.processActivityContent.id,
                                                  currentId,
                                                  answer
                                                  ).subscribe({
        next: r=>this.onOptionAnswered(),
        error: err=> this.snackbarService.error('Ocurrio un error inesperado'),
      });
    }else{
      if(this.currentIndex<this.dto.processActivityContent.cards.length){
        this.currentCard=this.dto.processActivityContent.cards[this.currentIndex++];
        this.canGoToNextCard = true;
        if(this.currentCard.readDateMobile){
          var filterCorrectedAnswer=this.currentCard.card.options.filter(o=>o.correct);
          if(filterCorrectedAnswer.length>0){
            this.answer=filterCorrectedAnswer[0];
          }
        }
      }else{
        this._bottomSheetRef.dismiss();
      }
    }
    //save answer
  }
  onOptionAnswered(){
    console.log(this.dto.processActivityContent.id)
    this.onboardingService.getProcessActivityContent(this.dto.userId,this.dto.processId,this.dto.processActivityId,this.dto.processActivityContent.content.id).subscribe({
      next : r=> {console.log(r);this.dto.processActivityContent=r;this.getCurrentCard()},
      error : err=>this.snackbarService.error('Ocurrio un error inesperado')
    })
  }
  getCurrentCard(){
    this.canGoToNextCard = false;
    var cardsUnreaded=this.dto.processActivityContent.cards.filter(pac=>!pac.readDateMobile);
    if(cardsUnreaded.length>0){
      this.currentCard = cardsUnreaded[0];
      setTimeout(()=>{
        this.canGoToNextCard= this.currentCard!.card.type!=Constants.ELEARNING_CONTENT_CARD_TYPE_VIDEO;
        this.canGoToNextCard = true;
      },2*1000)
      this.currentIndex= this.dto.processActivityContent.cards.findIndex(card=>card==cardsUnreaded[0])+1;
    }else{
      this.getResult();
    }
  }

    //falta agregar logica cuando 
    //falta pantalla resultado
  previousCard(){
    this.currentIndex--;
    this.currentCard=this.dto.processActivityContent.cards[this.currentIndex-1];
    this.canGoToNextCard = true; 
    if(this.currentCard.readDateMobile){
      var filterCorrectedAnswer=this.currentCard.card.options.filter(o=>o.correct);
      if(filterCorrectedAnswer.length>0){
        this.answer=filterCorrectedAnswer[0];
      }
    }    
  }
  getResult() {
    this.onboardingService.getResult(this.dto.userId,
                                      this.dto.processId,
                                      this.dto.processActivityId,
                                      this.dto.processActivityContent.id).subscribe({
      next: r=>{
        this.showResult=true;
        this.dto.processActivityContent.result=r.result;
      }
    });
  }
}
