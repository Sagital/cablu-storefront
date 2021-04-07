// react
import { memo } from 'react'

// third-party
//import { FormattedMessage } from 'react-intl';

// application
import AppLink from '../shared/AppLink'
import LogoSvg from '../../svg/logo.svg'
import NavPanel from './NavPanel'
import Search from './Search'
import Topbar from './Topbar'

export type HeaderLayout = 'default' | 'compact'

export interface HeaderProps {
  layout?: HeaderLayout
}

function Header(props: HeaderProps) {
  const { layout = 'default' } = props
  let bannerSection

  if (layout === 'default') {
    bannerSection = (
      <div className="site-header__middle container">
        <div className="site-header__logo">
          <AppLink href="/">
            <LogoSvg />
          </AppLink>
        </div>
        <div className="site-header__search">
          <Search context="header" />
        </div>
        <div className="site-header__phone">
          <div className="site-header__phone-title">
            {/*<FormattedMessage id="header.phoneLabel" defaultMessage="Customer Service" />*/}
          </div>
          <div className="site-header__phone-number">
            {/*<FormattedMessage id="header.phone" defaultMessage="(800) 060-0730" />*/}
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="site-header">
      <Topbar />
      {bannerSection}
      <div className="site-header__nav-panel">
        <NavPanel layout={layout} />
      </div>
    </div>
  )
}

export default memo(Header)
