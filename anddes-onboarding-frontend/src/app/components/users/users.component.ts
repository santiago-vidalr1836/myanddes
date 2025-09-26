import {AfterViewInit, ChangeDetectionStrategy, ChangeDetectorRef, Component, Inject, ViewChild} from '@angular/core';
import {
  MatDialog,
  MAT_DIALOG_DATA,
  MatDialogRef,
  MatDialogTitle,
  MatDialogContent,
  MatDialogActions,
  MatDialogClose,
} from '@angular/material/dialog';
import {MatPaginator, MatPaginatorIntl, MatPaginatorModule} from '@angular/material/paginator';
import {MatSort, MatSortModule} from '@angular/material/sort';
import {MatTableDataSource, MatTableModule} from '@angular/material/table';
import {MatInputModule} from '@angular/material/input';
import {MatFormFieldModule} from '@angular/material/form-field';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatIconModule } from '@angular/material/icon';
import { MatButtonModule } from '@angular/material/button';
import {} from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { catchError, map, merge, startWith, switchMap,of as observableOf, debounceTime, Subject, distinctUntilChanged  } from 'rxjs';
import { FormsModule } from '@angular/forms';
import * as XLSX from 'xlsx';
import { UserService } from '../../service/user.service';
import { UserData } from '../../entity/user';
import { Router } from '@angular/router';
import { AnddesCustomPaginatorIntl } from '../../service/anndes.custom.paginator.intl';

@Component({
  selector: 'app-users',
  standalone: true,
  imports: [MatFormFieldModule, MatInputModule, MatTableModule, MatSortModule, MatPaginatorModule,
            MatIconModule,MatButtonModule,
            CommonModule,MatProgressBarModule],
  providers: [{provide: MatPaginatorIntl, useClass: AnddesCustomPaginatorIntl}],          
  templateUrl: './users.component.html',
  styleUrl: './users.component.scss',
  changeDetection : ChangeDetectionStrategy.OnPush
})
export class UsersComponent implements AfterViewInit{
  isLoadingResults = true;
  resultsLength = 0;
  displayedColumns: string[] = ['image', 'fullname', 'roles', 'job', 'boss', 'action'];
  filter=''

  @ViewChild(MatPaginator) paginator: MatPaginator;
  @ViewChild(MatSort) sort: MatSort;
  private searchText$ = new Subject<string>();
  data:UserData[]=[]
  dataSource : MatTableDataSource<UserData>= new MatTableDataSource();
  acceptedFiles='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel'
  
  constructor(private router: Router,
              public dialog: MatDialog,
              private cdr: ChangeDetectorRef,
              private userService :UserService) {}

  ngAfterViewInit() {
    this.sort.sortChange.subscribe(() => (this.paginator.firstPage()));
    merge(this.sort.sortChange, 
          this.paginator.page,
          this.searchText$.pipe(debounceTime(300),distinctUntilChanged())
        )
      .pipe(
        startWith({}),
        switchMap(() => {
          this.isLoadingResults = true;
          return this.userService.listUsers(
            this.filter,
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
          return data.users;
        }),
      )
      .subscribe(data => (this.dataSource.data = data));
  }

  applyFilter(event: Event) {  
    this.filter=(event.target as HTMLInputElement).value;
    this.searchText$.next(this.filter);
  }
  userEdit(user: UserData) {
    this.router.navigate(['user/edit'],{state:user});
  }
  onFileSelected(event: Event){
    if ((event.target as HTMLInputElement).files && (event.target as HTMLInputElement).files.length) {
      this.isLoadingResults = true
      console.log((event.target as HTMLInputElement).files);

      let workBook = null;
      let jsonData = null;
      const reader = new FileReader();
      const file = (event.target as HTMLInputElement).files[0];
      reader.onload = (event) => {
        const data = reader.result;
        workBook = XLSX.read(data, { type: 'binary' });
        jsonData = workBook.SheetNames.reduce((initial, name) => {
          const sheet = workBook.Sheets[name];
          initial[name] = XLSX.utils.sheet_to_json(sheet);
          return initial;
        }, {});
        console.log(jsonData)
        if(jsonData.Sheet1 && jsonData.Sheet1.length!='undefined'){
          console.log('paso la validaction 1')
          var firstUser= jsonData.Sheet1[0];
          if(this.isValidColumns(firstUser)){
    
            this.userService.loadUsers(jsonData.Sheet1).subscribe((r:any)=>{
              if(r.newUsers && r.modifiedUsers){
                this.openDialog(r);
              }
            })
          }else{this.showError('Asegúrate que sea formato xls y que contenga las columnas Documento, Empleado, Cargo, Jefe y Correo.')}
        }else{this.showError('No se ha encontrado la pestaña Sheet1')}
      }
      reader.readAsArrayBuffer(file);
      (event.target as HTMLInputElement).value=null
    }
  }
  showError(error: string) {
    this.isLoadingResults=false
    console.log(error)
  }
  openDialog(data:UserData): void {
    const dialogRef = this.dialog.open(UserLoadDialog, {
      data: data,
    });
    dialogRef.afterClosed().subscribe(()=>{
      this.isLoadingResults=false
      this.cdr.detectChanges();
    });
  }
  isValidColumns(firstUser: any) : boolean {
    console.log(firstUser)
    return firstUser.Documento!=undefined && 
            firstUser.Empleado!=undefined &&
            firstUser.Cargo!=undefined && 
            //firstUser.Jefe!=undefined &&
            firstUser.correo!=undefined 
  }
}

export interface UserLoadData {
  newUsers: UserData[];
  modifiedUsers: UserData[];
  errors: UserData[];
}
@Component({
  selector: 'user-load-dialog',
  templateUrl: 'user-load.dialog.html',
  styleUrl:'user-load.dialog.css',
  standalone: true,
  imports: [
    MatFormFieldModule,
    MatInputModule,
    FormsModule,
    MatButtonModule,
    MatDialogTitle,
    MatDialogContent,
    MatDialogActions,
    MatDialogClose,
    CommonModule
  ],
})
export class UserLoadDialog {
  constructor(
    public dialogRef: MatDialogRef<UserLoadDialog>,
    @Inject(MAT_DIALOG_DATA) public data: UserLoadData,
  ) {

  }
  ngOnInit() {
    this.dialogRef.updateSize('763px', '513px');
  }

  onNoClick(): void {
    this.dialogRef.close();
  }
}


