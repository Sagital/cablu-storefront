// react
import { memo } from 'react'

// third-party
import classNames from 'classnames'

// application
import Cross20Svg from '../../svg/cross-20.svg'
import MobileLinks from './MobileLinks'

// data stubs
import dataMobileMenu from '../../data/mobileMenu'
import { IMobileMenuLink } from '../../interfaces/menus/mobile-menu'

function MobileMenu(props: any) {

  const classes = classNames('mobilemenu', {
    'mobilemenu--open': props.mobileMenuOpen,
  })

  const handleItemClick = (item: IMobileMenuLink) => {
    if (item.type === 'link') {
      props.setMobileMenuOpen(false)
    }
  }

  return (
    <div className={classes}>
      {/* eslint-disable-next-line max-len */}
      {/* eslint-disable-next-line jsx-a11y/no-static-element-interactions,jsx-a11y/click-events-have-key-events */}
      <div className="mobilemenu__backdrop" onClick={() => props.setMobileMenuOpen(false)} />
      <div className="mobilemenu__body">
        <div className="mobilemenu__header">
          <div className="mobilemenu__title">Menu</div>
          <button
            type="button"
            className="mobilemenu__close"
            onClick={() => props.setMobileMenuOpen(false)}
          >
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
