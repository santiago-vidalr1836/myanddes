import { Component, OnInit } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { Service } from '../../entity/service';
import { ServiceService } from '../../service/service.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-services',
  standalone: true,
  imports: [MatCardModule, MatButtonModule,MatProgressBarModule,MatIconModule],
  templateUrl: './services.component.html',
  styleUrl: './services.component.scss'
})
export class ServicesComponent implements OnInit{
  isLoadingResults=true;
  services : Service[] = []
  constructor(private router: Router,
              private serviceService : ServiceService
  ) {}
  ngOnInit(): void {
    this.serviceService.list().subscribe(r=>{
      this.services=r
      this.isLoadingResults=false
    });
  }
  edit(service: Service) {
    this.router.navigate(['service/edit'],{state:service});
  }
}
