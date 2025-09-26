import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ElearningContentAddComponent } from './elearning-content-add.component';

describe('ElearningContentAddComponent', () => {
  let component: ElearningContentAddComponent;
  let fixture: ComponentFixture<ElearningContentAddComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ElearningContentAddComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ElearningContentAddComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
