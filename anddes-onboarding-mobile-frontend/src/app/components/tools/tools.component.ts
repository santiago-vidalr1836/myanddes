import { Component, OnInit } from '@angular/core';
import {MatButtonModule} from '@angular/material/button';
import {MatCardModule} from '@angular/material/card';
import { MatIconModule } from '@angular/material/icon';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { Router } from '@angular/router';
import { Tool } from '../../entity/tool';
import { ToolService } from '../../service/tool.service';

@Component({
  selector: 'app-tools',
  standalone: true,
  imports: [MatCardModule, MatButtonModule,MatProgressBarModule,MatIconModule],
  templateUrl: './tools.component.html',
  styleUrl: './tools.component.scss'
})
export class ToolsComponent {

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
  openTool(tool: Tool) {
    window.open(tool.link, "_blank");
  }
}
