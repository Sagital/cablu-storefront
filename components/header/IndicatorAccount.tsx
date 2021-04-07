// application
import AppLink from '../shared/AppLink';
import Indicator from './Indicator';
import Person20Svg from '../../svg/person-20.svg';
import url from '../../services/url';

function IndicatorAccount() {
    const dropdown = (
        <div className="account-menu">
            <form className="account-menu__form">
                <div className="account-menu__form-title">Log In to Your Account</div>
                <div className="form-group">
                    <label htmlFor="header-signin-email" className="sr-only">Email address</label>
                    <input
                        id="header-signin-email"
                        type="email"
                        className="form-control form-control-sm"
                        placeholder="Email address"
                    />
                </div>
                <div className="form-group">
                    <label htmlFor="header-signin-password" className="sr-only">Password</label>
                    <div className="account-menu__form-forgot">
                        <input
                            id="header-signin-password"
                            type="password"
                            className="form-control form-control-sm"
                            placeholder="Password"
                        />
                        <AppLink href={url.accountSignIn()} className="account-menu__form-forgot-link">
                            Forgot?
                        </AppLink>
                    </div>
                </div>
                <div className="form-group account-menu__form-button">
                    <button type="submit" className="btn btn-primary btn-sm">Login</button>
                </div>
                <div className="account-menu__form-link">
                    <AppLink href={url.accountSignUp()}>Create An Account</AppLink>
                </div>
            </form>
            <div className="account-menu__divider" />
            <AppLink href={url.accountDashboard()} className="account-menu__user">
                <div className="account-menu__user-avatar">
                    <img src="/images/avatars/avatar-3.jpg" alt="" />
                </div>
                <div className="account-menu__user-info">
                    <div className="account-menu__user-name">Helena Garcia</div>
                    <div className="account-menu__user-email">stroyka@example.com</div>
                </div>
            </AppLink>
            <div className="account-menu__divider" />
            <ul className="account-menu__links">
                <li><AppLink href={url.accountProfile()}>Edit Profile</AppLink></li>
                <li><AppLink href={url.accountOrders()}>Order History</AppLink></li>
                <li><AppLink href={url.accountAddresses()}>Addresses</AppLink></li>
                <li><AppLink href={url.accountPassword()}>Password</AppLink></li>
            </ul>
            <div className="account-menu__divider" />
            <ul className="account-menu__links">
                <li><AppLink href={url.accountSignOut()}>Logout</AppLink></li>
            </ul>
        </div>
    );

    return (
        <Indicator url={url.accountSignIn()} dropdown={dropdown} icon={<Person20Svg />} />
    );
}

export default IndicatorAccount;
