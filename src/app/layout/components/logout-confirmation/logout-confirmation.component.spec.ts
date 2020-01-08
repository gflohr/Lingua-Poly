import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { LogoutConfirmationComponent } from './logout-confirmation.component';
import { TranslateModule } from '@ngx-translate/core';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';

describe('LogoutConfirmationComponent', () => {
	let component: LogoutConfirmationComponent;
	let fixture: ComponentFixture<LogoutConfirmationComponent>;

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				TranslateModule.forRoot()
			],
			declarations: [ LogoutConfirmationComponent ],
			providers: [
				NgbActiveModal
			]
		})
		.compileComponents();
	}));

	beforeEach(() => {
		fixture = TestBed.createComponent(LogoutConfirmationComponent);
		component = fixture.componentInstance;
		fixture.detectChanges();
	});

	it('should create', () => {
		expect(component).toBeTruthy();
	});
});
