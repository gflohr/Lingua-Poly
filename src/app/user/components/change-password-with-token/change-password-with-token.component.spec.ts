import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { ChangePasswordWithTokenComponent } from './change-password-with-token.component';

describe('ChangePasswordWithTokenComponent', () => {
  let component: ChangePasswordWithTokenComponent;
  let fixture: ComponentFixture<ChangePasswordWithTokenComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ ChangePasswordWithTokenComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(ChangePasswordWithTokenComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
