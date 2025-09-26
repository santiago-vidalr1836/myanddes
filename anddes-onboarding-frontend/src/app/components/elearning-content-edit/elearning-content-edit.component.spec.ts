import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ElearningContentEditComponent } from './elearning-content-edit.component';

describe('ElearningContentEditComponent', () => {
  let component: ElearningContentEditComponent;
  let fixture: ComponentFixture<ElearningContentEditComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ElearningContentEditComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ElearningContentEditComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
