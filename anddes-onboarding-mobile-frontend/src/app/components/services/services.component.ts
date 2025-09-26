import { Component, inject } from '@angular/core';
import { Service } from '../../entity/service';
import { Router } from '@angular/router';
import { ServiceService } from '../../service/service.service';
import { MatCardModule } from '@angular/material/card';
import { MatButtonModule } from '@angular/material/button';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import {
  MatBottomSheet,
  MatBottomSheetModule,
  MatBottomSheetRef,
} from '@angular/material/bottom-sheet';
import { ServiceDetailComponent } from '../service-detail/service-detail.component';

@Component({
  selector: 'app-services',
  standalone: true,
  imports: [MatCardModule, MatButtonModule, MatProgressBarModule, MatIconModule,MatBottomSheetModule],
  templateUrl: './services.component.html',
  styleUrl: './services.component.scss'
})
export class ServicesComponent {

  isLoadingResults = true
  services: Service[] = []
  constructor(private router: Router,
    private serviceService: ServiceService
  ) { }
  ngOnInit(): void {
    this.serviceService.list().subscribe(r => {
      this.services = r.sort((a1: Service, a2: Service) => a1.position - a2.position)
      this.isLoadingResults = false
    });
  }
  private _bottomSheet = inject(MatBottomSheet);
  detail(service: Service) {
    this.removeActiveFocus();
    //this.router.navigate(['service-detail'],{state:service});
    this._bottomSheet.open(ServiceDetailComponent,{data :service,hasBackdrop : true, panelClass: 'full-width'});
  }
  private removeActiveFocus() {
    if (document.activeElement instanceof HTMLElement) {
      document.activeElement.blur();
    }
  }
}
