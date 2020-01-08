import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { RegistrationComponent } from './registration.component';
import { TranslateModule } from '@ngx-translate/core';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { RouterTestingModule } from '@angular/router/testing';
import { HttpClientModule, HttpClient } from '@angular/common/http';

describe('RegistrationComponent', () => {
	let component: RegistrationComponent;
	let fixture: ComponentFixture<RegistrationComponent>;

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				FormsModule,
				ReactiveFormsModule,
				RouterTestingModule,
				TranslateModule.forRoot(),
				HttpClientModule
			],
			declarations: [ RegistrationComponent ],
			providers: [
				HttpClientModule
			]
		})
		.compileComponents();
	}));

	beforeEach(() => {
		fixture = TestBed.createComponent(RegistrationComponent);
		component = fixture.componentInstance;
		fixture.detectChanges();
	});

	it('should create', () => {
		expect(component).toBeTruthy();
	});
});
