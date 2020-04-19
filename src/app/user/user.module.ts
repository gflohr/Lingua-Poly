import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProfileComponent } from './components/profile/profile.component';
import { RouterModule } from '@angular/router';
import { userRoutes } from './user.routes';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { CoreModule } from '../core/core.module';
import { ChangePasswordComponent } from './components/change-password/change-password.component';
import { ResetPasswordComponent } from './components/reset-password/reset-password.component';
import { ChangePasswordWithTokenComponent } from './components/change-password-with-token/change-password-with-token.component';
import { DeleteAccountConfirmationComponent } from './components/delete-account-confirmation/delete-account-confirmation.component';

@NgModule({
	imports: [
		CommonModule,
		CoreModule,
		RouterModule.forChild(userRoutes),
		FormsModule,
		ReactiveFormsModule
	],
	declarations: [ProfileComponent, ChangePasswordComponent, ResetPasswordComponent, ChangePasswordWithTokenComponent, DeleteAccountConfirmationComponent]
})
export class UserModule { }
