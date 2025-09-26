import { Component, OnInit } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { Location } from '@angular/common';
import {} from '@angular/common/http';
import { MatInputModule } from '@angular/material/input';
import { ToolService } from '../../service/tool.service';
import { FileService } from '../../service/file.service';
import { Tool } from '../../entity/tool';
import { Router } from '@angular/router';
import 'moment/locale/es-mx';

@Component({
  selector: 'app-tool-add-edit',
  standalone: true,
  imports: [MatIconModule,
            MatButtonModule,
            FormsModule,
            MatFormFieldModule,
            ReactiveFormsModule,
            MatInputModule
  ],
  templateUrl: './tool-add-edit.component.html',
  styleUrl: './tool-add-edit.component.scss'
})
export class ToolAddEditComponent implements OnInit{

  acceptedFiles = 'image/*'
  tool : Tool
  constructor(private router: Router,
              private location:Location,
              private toolService : ToolService,
              private fileService : FileService) {}
  ngOnInit(): void {
    if(typeof window !== 'undefined'){
      this.tool=window.history.state
    }else{
      this.tool = new Tool()
    } 
  }
  back() {
    this.location.back()
  }
  saveTool() {
    if(this.tool.id){
      this.toolService.update(this.tool).subscribe(()=>{
        this.back()
      })
    }else{
      this.toolService.add(this.tool).subscribe(()=>{
        this.back()
      })
    }    
  }
  onFileSelected(event){
    if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files.length) {
      const file = (event.target as HTMLInputElement).files[0];
      this.fileService.upload(file).subscribe((r:any)=>this.tool.cover=r.url);
      (event.target as HTMLInputElement).value=null
    }
  }
  getFileNameFromUrl(url: string) {
    return url.split('/').pop();
  }
}
