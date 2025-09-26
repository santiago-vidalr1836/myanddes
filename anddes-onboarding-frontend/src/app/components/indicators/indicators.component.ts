import { AfterViewInit, Component } from '@angular/core';
import { FormControl, FormGroup, FormsModule, ReactiveFormsModule } from '@angular/forms';
import { provideMomentDateAdapter } from '@angular/material-moment-adapter';
import { MAT_DATE_LOCALE } from '@angular/material/core';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { UtilService } from '../../service/util.service';
import { ProcessService } from '../../service/process.service';
import { MatCardModule } from '@angular/material/card';
import annotationPlugin from  'chartjs-plugin-annotation'
import { ChartConfiguration, ChartData, ChartEvent, ChartType , Chart } from 'chart.js';
import { BaseChartDirective } from 'ng2-charts';
import { Indicator } from '../../entity/process';

Chart.register(annotationPlugin)
const today = new Date();

@Component({
  selector: 'app-indicators',
  standalone: true,
  
  imports: [MatProgressBarModule,
            MatFormFieldModule, 
            MatDatepickerModule, 
            FormsModule, 
            ReactiveFormsModule,
            MatCardModule,
            BaseChartDirective
  ],
  providers: [
    {provide: MAT_DATE_LOCALE, useValue: 'es-ES'},
    provideMomentDateAdapter(),
  ],
  templateUrl: './indicators.component.html',
  styleUrl: './indicators.component.scss'
})
export class IndicatorsComponent implements AfterViewInit{
  isLoadingResults : true
  indicator = new Indicator()
  dateFilter = new FormGroup({
    start: new FormControl(this.utilService.addDays(new Date(),-7)),
    end: new FormControl(new Date()),
  });
  
  constructor(private utilService : UtilService,
              private processService : ProcessService){}
  ngAfterViewInit(): void {
    this.processService.getIndicators(this.dateFilter.value.start.toISOString(),this.dateFilter.value.end.toISOString()).subscribe(r=>{
      console.log(r)
      this.indicator = r;

      this.barChartData.datasets=[{ data: [this.indicator.completedELearning,this.indicator.averageELearningCompleted], label: 'Procesos', 
        backgroundColor : ['#9DC9D2 ']
      }]
      var percentage = Math.round(this.indicator.completedProcesses*100/this.indicator.totalProcesses)
      this.doughnutChartData.datasets = [
      { data: [percentage,100-percentage], 
          backgroundColor:[
            '#7d82cc',
            '#ced0ed'
          ]
        },
      ]
      //console.log(this.doughnutChartData)
      var percentage = this.indicator.totalProcesses>0?Math.round(this.indicator.completedProcesses/this.indicator.totalProcesses*100):0;
      Chart.getChart('indicator-doughnut-chart').options.plugins.annotation.annotations["label1"].content= 
      [percentage+'%','completados']
      Chart.getChart('indicator-doughnut-chart').update()
      Chart.getChart('indicator-bar-chart').update()
    });
  }
   
  // Doughnut
  public doughnutChartLabels: string[] = ['Completados'];
  public doughnutChartData: ChartData<'doughnut'> = {
    labels: this.doughnutChartLabels,
    datasets: [
      { data: [this.indicator.completedProcesses,this.indicator.totalProcesses-this.indicator.completedProcesses], 
        backgroundColor:[
          '#7d82cc',
          '#ced0ed'
        ]
      },
    ],  
  };
  public doughnutChartType: ChartType = 'doughnut'; 
  public doughnutChartOptions:any = { 
    cutout : 150,
    radius : '40%',
    plugins :  {
      legend : {
        display : false
      },
      annotation: {
        annotations: {
          label1: {
            type: 'label',
            xValue: 0.5,
            yValue: 0.5,
            backgroundColor: 'rgba(245,245,245, 0.9)',
            content:  [0+'%','completados'],
            font: {
              size: 16
            }
          },
        }
      }
    }
  };

  public barChartOptions: any = {
    barThickness: 30,
    // We use these empty structures as placeholders for dynamic theming.
    scales: {
      x: {
      },
      y: {
        min: 10,
      },
    },
    plugins: {
      legend: {
        display: false,
      },
      datalabels: {
        anchor: 'end',
        align: 'end',
      },
    },
  };
  public barChartType = 'bar' as const;

  public barChartData: ChartData<'bar'> = {
    labels: ['Completados', 'Prom. calif'],
    datasets: [
      { data: [0,0], label: 'Procesos', 
        backgroundColor : ['#9DC9D2 ']
      },
    ],
  };
}
