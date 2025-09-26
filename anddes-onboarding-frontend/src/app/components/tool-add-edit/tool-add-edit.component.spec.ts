import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ToolAddEditComponent } from './tool-add-edit.component';

describe('ToolAddEditComponent', () => {
  let component: ToolAddEditComponent;
  let fixture: ComponentFixture<ToolAddEditComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ToolAddEditComponent]
    })
    .compileComponents();
    
    fixture = TestBed.createComponent(ToolAddEditComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
