import { Component, OnInit } from '@angular/core';
import { ELearningContent } from '../../entity/activity';
import { Location } from '@angular/common';
import { Router } from '@angular/router';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { MatMenuModule } from '@angular/material/menu';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { FileService } from '../../service/file.service';

@Component({
  selector: 'app-elearning-content-add',
  standalone: true,
  imports: [MatIconModule,
            MatButtonModule,
            MatMenuModule,
            MatFormFieldModule,
            MatInputModule,
            FormsModule,
            ReactiveFormsModule
    ],
  templateUrl: './elearning-content-add.component.html',
  styleUrl: './elearning-content-add.component.scss'
})
export class ElearningContentAddComponent implements OnInit {

  acceptedFiles = 'image/*'
  content : ELearningContent = new ELearningContent();

  constructor(
    private location : Location,
    private router: Router,
    private fileService: FileService
  ){}

  ngOnInit(): void {
    if(typeof window !== 'undefined'){
      this.content=window.history.state
    }
  }
  back(){
    this.location.back()
  }
  next(){
    this.router.navigate(['elearning-content/add/content'],{state:this.content});
  }
  onFileSelected(event){
    if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files.length) {
      const file = (event.target as HTMLInputElement).files[0];
      this.fileService.upload(file).subscribe((r:any)=>this.content.image=r.url);
      (event.target as HTMLInputElement).value=null
    }
  }
  getFileNameFromUrl(url: string) {
    return url.split('/').pop();
  }

}
