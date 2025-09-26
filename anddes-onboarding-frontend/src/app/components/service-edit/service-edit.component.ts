import { Location } from '@angular/common';
import { Component } from '@angular/core';
import { Service } from '../../entity/service';
import { ServiceService } from '../../service/service.service';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { MatFormFieldModule } from '@angular/material/form-field';
import {} from '@angular/common/http';
import { MatInputModule } from '@angular/material/input';
import { Router } from '@angular/router';

@Component({
  selector: 'app-service-edit',
  standalone: true,
  imports: [MatIconModule,
            MatButtonModule,
            FormsModule,
            MatFormFieldModule,
            ReactiveFormsModule,
            MatInputModule],
  templateUrl: './service-edit.component.html',
  styleUrl: './service-edit.component.scss'
})
export class ServiceEditComponent {
  service : Service = new Service()
  constructor(private router: Router,
              private location:Location,
              private serviceService : ServiceService) {
    if(typeof window !== 'undefined'){
      this.service=window.history.state
    }
  }
  ngOnInit(): void {
    
  }
  back() {
    this.location.back()
  }
  save(){
    this.serviceService.update(this.service).subscribe(()=>{
      this.router.navigate(['service/detail'],{state:this.service});
    })
  }
}
