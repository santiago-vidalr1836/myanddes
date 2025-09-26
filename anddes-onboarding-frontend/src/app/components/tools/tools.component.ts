import { Component, OnInit } from '@angular/core';
import {MatButtonModule} from '@angular/material/button';
import {MatCardModule} from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { Router } from '@angular/router';
import { ToolService } from '../../service/tool.service';
import { Tool } from '../../entity/tool';

@Component({
  selector: 'app-tools',
  standalone: true,
  imports: [MatCardModule, MatButtonModule,MatProgressBarModule,MatIconModule],
  templateUrl: './tools.component.html',
  styleUrl: './tools.component.scss'
})
export class ToolsComponent implements OnInit{
  isLoadingResults=true
  tools: Tool[]=[]
  constructor(private router: Router,
              private toolService : ToolService
  ) {}
  ngOnInit(): void {
    this.toolService.list().subscribe(r=>{
      this.tools=r
      this.isLoadingResults=false
    });
  }
  edit(tool: Tool) {
    this.router.navigate(['tool/modify'],{state:tool});
  }
  add() {
    this.router.navigate(['tool/modify']);
  }

}
