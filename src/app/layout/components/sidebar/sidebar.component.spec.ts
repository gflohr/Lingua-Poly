import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { SidebarComponent } from './sidebar.component';
import { TranslateModule } from '@ngx-translate/core';
import { provideMockStore } from '@ngrx/store/testing';
import { authFeatureKey } from '../../../auth/reducers';

describe('SidebarComponent', () => {
	let component: SidebarComponent;
	let fixture: ComponentFixture<SidebarComponent>;
	const initialState = { [authFeatureKey]: {} };

	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				TranslateModule.forRoot()
			],
			declarations: [ SidebarComponent ],
			providers: [
				provideMockStore({ initialState })
			]
		})
		.compileComponents();
	}));

	beforeEach(() => {
		fixture = TestBed.createComponent(SidebarComponent);
		component = fixture.componentInstance;
		fixture.detectChanges();
	});

	afterEach(() => { fixture.destroy(); });

	it('should create', () => {
		expect(component).toBeTruthy();
	});
});
