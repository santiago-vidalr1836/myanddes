import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RemoteInductionEditComponent } from './remote-induction-edit.component';

describe('RemoteInductionEditComponent', () => {
  let component: RemoteInductionEditComponent;
  let fixture: ComponentFixture<RemoteInductionEditComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RemoteInductionEditComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RemoteInductionEditComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
