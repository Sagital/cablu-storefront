// application
import AppLink from '../shared/AppLink'
import CartIndicator from './IndicatorCart'
import Departments from './Departments'
import Heart20Svg from '../../svg/heart-20.svg'
import Indicator from './Indicator'
import IndicatorAccount from './IndicatorAccount'
import IndicatorSearch from './IndicatorSearch'
import LogoSmallSvg from '../../svg/logo-small.svg'
import NavLinks from './NavLinks'

export type NavPanelLayout = 'default' | 'compact'

export interface NavPanelProps {
  layout?: NavPanelLayout
}

function NavPanel(props: NavPanelProps) {
  const { layout = 'default' } = props

  const wishlistCount = 20

  // const {
  //   items: { length: wishlistCount },
  // } = useWishlist()

  let logo = null
  let departments = null
  let searchIndicator

  if (layout === 'compact') {
    logo = (
      <div className="nav-panel__logo">
        <AppLink href="/">
          <LogoSmallSvg />
        </AppLink>
      </div>
    )

    searchIndicator = <IndicatorSearch />
  }

  if (layout === 'default') {
    departments = (
      <div className="nav-panel__departments">
        <Departments />
      </div>
    )
  }

  return (
    <div className="nav-panel">
      <div className="nav-panel__container container">
        <div className="nav-panel__row">
          {logo}
          {departments}

          <div className="nav-panel__nav-links nav-links">
            <NavLinks />
          </div>

          <div className="nav-panel__indicators">
            {searchIndicator}

            {/*<Indicator url="/shop/wishlist" value={wishlistCount} icon={<Heart20Svg />} />*/}

            <CartIndicator />

            {/*<IndicatorAccount />*/}
          </div>
        </div>
      </div>
    </div>
  )
}

export default NavPanel
