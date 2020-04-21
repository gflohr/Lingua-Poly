import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LinguaSelectorComponent } from './lingua-selector.component';

describe('LinguaSelectorComponent', () => {
  let component: LinguaSelectorComponent;
  let fixture: ComponentFixture<LinguaSelectorComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ LinguaSelectorComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(LinguaSelectorComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
