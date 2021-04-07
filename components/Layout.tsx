// react
import { Fragment, PropsWithChildren } from 'react';

// third-party
import { ToastContainer } from 'react-toastify';

// application
import Footer from './footer/Footer';
import Header, { HeaderLayout } from './header/Header';
import MobileHeader from './mobile/MobileHeader';
import MobileMenu from './mobile/MobileMenu';
import Quickview from './shared/Quickview';

export interface LayoutProps extends PropsWithChildren<{}>{
    headerLayout: HeaderLayout;
}

function Layout(props : LayoutProps) {
    const { children, headerLayout } = props;

    return (
        <Fragment>
            <ToastContainer autoClose={5000} hideProgressBar />

            <Quickview />

            <MobileMenu />

            <div className="site">
                <header className="site__header d-lg-none">
                    <MobileHeader />
                </header>

                <header className="site__header d-lg-block d-none">
                    <Header layout={headerLayout} />
                </header>

                <div className="site__body">
                    {children}
                </div>

                <footer className="site__footer">
                    <Footer />
                </footer>
            </div>
        </Fragment>
    );
}

export default Layout;
