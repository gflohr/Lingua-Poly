import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProfileComponent } from './components/profile/profile.component';
import { RouterModule } from '@angular/router';
import { userRoutes } from './user.routes';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CoreModule } from '../core/core.module';
import { ChangePasswordComponent } from './components/change-password/change-password.component';
import { ResetPasswordComponent } from './components/reset-password/reset-password.component';

@NgModule({
	imports: [
		CommonModule,
		CoreModule,
		RouterModule.forChild(userRoutes),
		FormsModule,
		ReactiveFormsModule
	],
	declarations: [ProfileComponent, ChangePasswordComponent, ResetPasswordComponent]
})
export class UserModule { }
