import { AfterViewInit, Component } from '@angular/core';

@Component({
  selector: 'app-home',
  imports: [],
  standalone: true,
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent implements AfterViewInit {
  constructor() { 
    console.log('Home')
  }
  ngAfterViewInit(): void {
  }
}
