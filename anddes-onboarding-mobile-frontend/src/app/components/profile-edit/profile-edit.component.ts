import { AsyncPipe } from '@angular/common';
import {LiveAnnouncer} from '@angular/cdk/a11y';
import {ChangeDetectionStrategy, ChangeDetectorRef, Component, inject, OnInit, signal} from '@angular/core';
import { FormControl, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { Profile } from '../../entity/profile';
import {MatChipInputEvent, MatChipsModule} from '@angular/material/chips';
import { ProfileService } from '../../service/profile.service';
import { Router } from '@angular/router';
import { FileService } from '../../service/file.service';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { ProcessActivity } from '../../entity/process-activity';
import { forkJoin } from 'rxjs';
import { OnboardingService } from '../../service/onboarding.service';

@Component({
  selector: 'app-profile-edit',

  imports: [MatIconModule,
    MatButtonModule,
    FormsModule,
    MatFormFieldModule,
    ReactiveFormsModule,
    MatInputModule,
    MatDatepickerModule,
    MatChipsModule,
    MatProgressBarModule],
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: './profile-edit.component.html',
  styleUrl: './profile-edit.component.scss'
})
export class ProfileEditComponent implements OnInit{
  isLoadingResults = true;
  acceptedImage = 'image/*'
  profile = {} as Profile;
  keywords = signal([] as string[]);

  announcer = inject(LiveAnnouncer);
  profileActivity = {} as ProcessActivity;
  constructor(private profileService : ProfileService,
              private router : Router,
              private fileService : FileService,
              private cdr: ChangeDetectorRef,
              private onboardingService:OnboardingService
  ){
    this.profileActivity = history.state;
  }
  ngOnInit(): void {
    this.profileService.getProfile().subscribe({
      next: r=>{
        console.log(r)
        this.profile.nickname=r.nickname;
        this.profile.image=r.image;
        this.profile.hobbies=r.hobbies;
        this.keywords.set(this.profile.hobbies);
      },
      error: e=>{console.log(e)},
      complete: ()=>{this.isLoadingResults=false;this.cdr.detectChanges();}
    });
  }
  removeKeyword(keyword: string) {
    this.keywords.update(keywords => {
      const index = keywords.indexOf(keyword);
      if (index < 0) {
        return keywords;
      }
      keywords.splice(index, 1);
      this.announcer.announce(`removed ${keyword}`);
      return [...keywords];
    });
  }

  add(event: MatChipInputEvent): void {
    const value = (event.value || '').trim();
    // Add our keyword
    if (value) {
      this.keywords.update(keywords => [...keywords, value]);
    }
    // Clear the input value
    event.chipInput!.clear();
  }
  save(){
    var jsonAuth =localStorage.getItem("auth");
    var jsonProcess =localStorage.getItem("process");
    if(jsonAuth=== undefined || jsonProcess === undefined){
      this.router.navigate(['services']);
      return;
    }
    var auth = JSON.parse(jsonAuth!);
    var process = JSON.parse(jsonProcess!);
    if(!this.profileActivity.completed){
      this.onboardingService.updateCompletedActivities(auth.id,process.id,[this.profileActivity]).subscribe()  
    }
    this.profileService.updateProfile({"userId":auth.id,
                                       "nickname":this.profile.nickname,
                                       "image":this.profile.image,
                                       "hobbies":this.profile.hobbies
    }).subscribe(()=>{
      setTimeout(()=>{
        this.goToActivityList();
      },1000)
    })
  }
  getFilename(url: string) {
    return url.split('/').pop();
  }
  goToActivityList(){
    this.router.navigate(['/activity-list']);
  }
  onImageSelected(event: Event){
    if (!(event.target as HTMLInputElement).files) return;
    this.isLoadingResults = true 
    if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files!.length) {
      const file = (event.target as HTMLInputElement).files![0];
      this.fileService.upload(file).subscribe((r:any)=>{
        this.profile.image=r.url;
        (event.target as HTMLInputElement).value!=null
        this.isLoadingResults = false
        this.cdr.detectChanges();
      });
    }
  }
}
