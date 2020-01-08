import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistrationReceivedComponent } from './registration-received.component';

describe('RegistrationReceivedComponent', () => {
	let component: RegistrationReceivedComponent;
	let fixture: ComponentFixture<RegistrationReceivedComponent>;

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			declarations: [ RegistrationReceivedComponent ]
		})
		.compileComponents();
	}));

	beforeEach(() => {
		fixture = TestBed.createComponent(RegistrationReceivedComponent);
		component = fixture.componentInstance;
		fixture.detectChanges();
	});

	it('should create', () => {
		expect(component).toBeTruthy();
	});
});
