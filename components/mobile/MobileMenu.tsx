// react
import { memo } from 'react'

// third-party
import classNames from 'classnames'

// application
import Cross20Svg from '../../svg/cross-20.svg'
import MobileLinks from './MobileLinks'
// import { useCurrencyChange } from '../../store/currency/currencyHooks';
// import { useLocaleChange } from '../../store/locale/localeHooks';
// import { useMobileMenu, useMobileMenuClose } from '../../store/mobile-menu/mobileMenuHooks';

// data stubs
import dataMobileMenu from '../../data/mobileMenu'
//import dataShopCurrencies from '../../data/shopCurrencies'
import { IMobileMenuLink } from '../../interfaces/menus/mobile-menu'

function MobileMenu() {
  const mobileMenu = { open: '' }
  const mobileMenuClose = () => console.log('mobile menu close')
  // const localeChange = useLocaleChange()
  // const currencyChange = useCurrencyChange()

  const classes = classNames('mobilemenu', {
    'mobilemenu--open': mobileMenu.open,
  })

  const handleItemClick = (item: IMobileMenuLink) => {
    // if (item.data) {
    //   if (item.data.type === 'language') {
    //     localeChange(item.data.locale)
    //     mobileMenuClose()
    //   }
    //   if (item.data.type === 'currency') {
    //     const currency = dataShopCurrencies.find(x => x.code === item.data.code)
    //
    //     if (currency) {
    //       currencyChange(currency)
    //       mobileMenuClose()
    //     }
    //   }
    // }
    // if (item.type === 'link') {
    //   mobileMenuClose()
    // }
  }

  return (
    <div className={classes}>
      {/* eslint-disable-next-line max-len */}
      {/* eslint-disable-next-line jsx-a11y/no-static-element-interactions,jsx-a11y/click-events-have-key-events */}
      <div className="mobilemenu__backdrop" onClick={mobileMenuClose} />
      <div className="mobilemenu__body">
        <div className="mobilemenu__header">
          <div className="mobilemenu__title">Menu</div>
          <button type="button" className="mobilemenu__close" onClick={mobileMenuClose}>
            <Cross20Svg />
          </button>
        </div>
        <div className="mobilemenu__content">
          <MobileLinks links={dataMobileMenu} onItemClick={handleItemClick} />
        </div>
      </div>
    </div>
  )
}

export default memo(MobileMenu)
