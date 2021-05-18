// react
import { useEffect, useRef, useState, memo, useCallback } from 'react'

// third-party
import classNames from 'classnames'

// application
import AppLink from '../shared/AppLink'
import Cart20Svg from '../../svg/cart-20.svg'
import Indicator from '../header/Indicator'
import LogoSmallSvg from '../../svg/logo-small.svg'
import Menu18x14Svg from '../../svg/menu-18x14.svg'
import Search from '../header/Search'
import Search20Svg from '../../svg/search-20.svg'
import url from '../../services/url'

function MobileHeader(props: any) {
  const [searchOpen, setSearchOpen] = useState(false)

  const inputRef = useRef<HTMLInputElement | null>(null)
  const cart = { quantity: 20 }

  useEffect(() => {
    if (searchOpen && inputRef.current) {
      inputRef.current.focus()
    }
  }, [searchOpen])

  const handleOpenSearch = () => {
    setSearchOpen(true)
  }

  const handleCloseSearch = useCallback(() => {
    setSearchOpen(false)
  }, [])

  const searchClasses = classNames('mobile-header__search', {
    'mobile-header__search--open': searchOpen,
  })

  return (
    <div className="mobile-header">
      <div className="mobile-header__panel">
        <div className="container">
          <div className="mobile-header__body">
            <button
              type="button"
              className="mobile-header__menu-button"
              onClick={() => props.setMobileMenuOpen(true)}
            >
              <Menu18x14Svg />
            </button>
            <AppLink href={url.home()} className="mobile-header__logo">
              <LogoSmallSvg />
            </AppLink>
            <Search
              context="mobile-header"
              className={searchClasses}
              inputRef={inputRef}
              onClose={handleCloseSearch}
            />
            <div className="mobile-header__indicators">
              <Indicator
                className="indicator--mobile indicator--mobile-search d-md-none"
                onClick={handleOpenSearch}
                icon={<Search20Svg />}
              />
              <Indicator
                className="indicator--mobile"
                url={url.cart()}
                value={cart.quantity}
                icon={<Cart20Svg />}
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default memo(MobileHeader)
