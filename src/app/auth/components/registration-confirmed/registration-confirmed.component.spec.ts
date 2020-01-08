import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistrationConfirmedComponent } from './registration-confirmed.component';
import { RouterTestingModule } from '@angular/router/testing';

describe('RegistrationConfirmedComponent', () => {
	let component: RegistrationConfirmedComponent;
	let fixture: ComponentFixture<RegistrationConfirmedComponent>;

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [RouterTestingModule],
			declarations: [ RegistrationConfirmedComponent ]
		})
		.compileComponents();
	}));

	beforeEach(() => {
		fixture = TestBed.createComponent(RegistrationConfirmedComponent);
		component = fixture.componentInstance;
		fixture.detectChanges();
	});

	it('should create', () => {
		expect(component).toBeTruthy();
	});
});
