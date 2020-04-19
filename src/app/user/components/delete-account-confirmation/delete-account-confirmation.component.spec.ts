import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { DeleteAccountConfirmationComponent } from './delete-account-confirmation.component';

describe('DeleteAccountConfirmationComponent', () => {
  let component: DeleteAccountConfirmationComponent;
  let fixture: ComponentFixture<DeleteAccountConfirmationComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ DeleteAccountConfirmationComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(DeleteAccountConfirmationComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
