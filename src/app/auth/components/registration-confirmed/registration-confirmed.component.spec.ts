import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistrationConfirmedComponent } from './registration-confirmed.component';
import { RouterTestingModule } from '@angular/router/testing';
import { HttpClientModule } from '@angular/common/http';

describe('RegistrationConfirmedComponent', () => {
	let component: RegistrationConfirmedComponent;
	let fixture: ComponentFixture<RegistrationConfirmedComponent>;

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				RouterTestingModule,
				HttpClientModule
			],
			declarations: [ RegistrationConfirmedComponent ],
			providers: [
				HttpClientModule
			]
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
