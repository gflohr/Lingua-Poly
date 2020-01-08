import { TestBed, async } from '@angular/core/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { AppComponent } from './app.component';
import { CoreModule } from './core/core.module';
import { LayoutModule } from './layout/layout.module';
import { ROOT_REDUCERS, metaReducers } from './app.reducers';
import { StoreModule } from '@ngrx/store';

describe('AppComponent', () => {
	beforeEach(async(() => {
		TestBed.configureTestingModule({
			imports: [
				CoreModule,
				LayoutModule,
				RouterTestingModule,
				StoreModule.forRoot(ROOT_REDUCERS, { metaReducers }),
			],
			declarations: [
				AppComponent
			],
		}).compileComponents();
	}));

	it('should create the app', () => {
		const fixture = TestBed.createComponent(AppComponent);
		const app = fixture.debugElement.componentInstance;
		expect(app).toBeTruthy();
	});
});
