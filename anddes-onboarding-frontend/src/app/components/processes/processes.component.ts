import { CommonModule } from '@angular/common';
import { AfterViewInit, ChangeDetectorRef, Component, ViewChild } from '@angular/core';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatIconModule } from '@angular/material/icon';
import { MatInputModule } from '@angular/material/input';
import { MatPaginator, MatPaginatorIntl, MatPaginatorModule } from '@angular/material/paginator';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatSort, MatSortModule } from '@angular/material/sort';
import { MatTableDataSource, MatTableModule } from '@angular/material/table';
import { Process } from '../../entity/process';
import { Router } from '@angular/router';
import { ProcessService } from '../../service/process.service';
import { merge, startWith, switchMap,of as observableOf, catchError, map, take } from 'rxjs';
import { AnddesCustomPaginatorIntl } from '../../service/anndes.custom.paginator.intl';
import { MatDialog } from '@angular/material/dialog';
import { SelectReportDialog } from './select-report-dialog/select.report.dialog';
import { HttpResponse } from '@angular/common/http';

@Component({
  selector: 'app-processes',
  standalone: true,
  imports: [MatFormFieldModule, MatInputModule, MatTableModule, MatSortModule, MatPaginatorModule,
    MatIconModule,MatButtonModule,
    CommonModule,MatProgressBarModule],
  providers: [{provide: MatPaginatorIntl, useClass: AnddesCustomPaginatorIntl}],
  templateUrl: './processes.component.html',
  styleUrl: './processes.component.scss'
})
export class ProcessesComponent implements AfterViewInit{
  isLoadingResults = true;
  resultsLength = 0;
  displayedColumns: string[] = ['id', 'user', 'startDate', 'status', 'action'];
  data:Process[]=[]
  dataSource : MatTableDataSource<Process>= new MatTableDataSource();

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  
  constructor(private router: Router,
    private cdr: ChangeDetectorRef,
    private processService :ProcessService,
    public dialog: MatDialog) {

  }
  ngAfterViewInit() {
    this.sort.sortChange.subscribe(() => (this.paginator.firstPage()));
    merge(this.sort.sortChange, 
          this.paginator.page
        )
      .pipe(
        startWith({}),
        switchMap(() => {
          this.isLoadingResults = true;
          return this.processService.list(
            this.sort.active,
            this.sort.direction,
            this.paginator.pageIndex,
            this.paginator.pageSize
          ).pipe(catchError(() => observableOf(null)));
        }),
        map(data => {
          // Flip flag to show that loading has finished.
          this.isLoadingResults = false;
          if (data === null) {
            return [];
          }
          // Only refresh the result length if there is new data. In case of rate
          // limit errors, we do not want to reset the paginator to zero, as that
          // would prevent users from re-triggering requests.
          this.resultsLength = data.total;
          return data.processes;
        }),
      )
      .subscribe(data => (this.dataSource.data = data));
  }
  edit(process: Process) {
    this.router.navigate(['process/edit'],{state:process});
  }
  add() {
    this.router.navigate(['process/add']);
  }
  download() {
    const dialogRef = this.dialog.open(SelectReportDialog);
    dialogRef.afterClosed().subscribe((result:string)=>{
      if(result && result.length>0){
        this.isLoadingResults=true;
        if(result=='process'){
          this.processService.downloadProcess().pipe(take(1)).subscribe((response=>this.downloadFile(response)));
        }else if(result=='answers'){
          this.processService.downloadAnswers().pipe(take(1)).subscribe((response=>this.downloadFile(response)));
        }
      }
    });
  }
  downloadFile(response: HttpResponse<Blob>){
    console.log(response)
    const downloadLink = document.createElement('a');
    downloadLink.href = URL.createObjectURL(new Blob([response.body], { type: response.body.type }));
    const contentDisposition = response.headers.get('Content-Disposition');
    const fileName = contentDisposition.split(';')[1].split('filename')[1].split('=')[1].trim();
    downloadLink.download = fileName.replace('"',"").replace('"',"");
    downloadLink.click();
    this.isLoadingResults=false;
  }
}
