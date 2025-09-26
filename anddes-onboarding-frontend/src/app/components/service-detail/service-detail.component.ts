import { Location } from '@angular/common';
import {} from '@angular/common/http';
import { Component, Inject } from '@angular/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { ContentChange, QUILL_CONFIG_TOKEN, QuillConfig, QuillEditorComponent, QuillModule } from 'ngx-quill'
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatSlideToggleModule } from '@angular/material/slide-toggle';
import { Service } from '../../entity/service';
import { ServiceService } from '../../service/service.service';
import { HtmlEditorComponent } from '../html-editor/html-editor.component';
import { MatDividerModule } from '@angular/material/divider';
import { Router } from '@angular/router';

@Component({
  selector: 'app-service-detail',
  standalone: true,
  
  imports: [HtmlEditorComponent,
            MatIconModule,
            MatButtonModule,
            FormsModule,
            MatFormFieldModule,
            ReactiveFormsModule,
            MatInputModule,
            MatSlideToggleModule,
            MatInputModule,
            MatDividerModule],
  templateUrl: './service-detail.component.html',
  styleUrl: './service-detail.component.scss'
})
export class ServiceDetailComponent {


  service : Service
  constructor(private location:Location,
              private serviceService : ServiceService,
              private router:Router) {
    if(typeof window !== 'undefined'){
      this.service=window.history.state
    }
  }
  ngOnInit(): void {
    
  }
  back() {
    this.location.back()
  }
  save() {
    this.serviceService.updateDetail(this.service).subscribe(()=>this.router.navigate(['services']))
  }
}
