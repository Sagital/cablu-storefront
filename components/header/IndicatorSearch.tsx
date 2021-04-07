// react
import { Fragment, useRef } from 'react';

// application
import Cross20Svg from '../../svg/cross-20.svg';
import Indicator from './Indicator';
import Search from './Search';
import Search20Svg from '../../svg/search-20.svg';

function IndicatorSearch() {
    const inputRef = useRef<HTMLInputElement>(null);
    const indicatorRef = useRef<Indicator>(null);

    const handleOpen = () => {
        if (inputRef.current) {
            inputRef.current.focus();
        }
    };

    const handleClose = () => {
        if (indicatorRef.current) {
            indicatorRef.current.close();
        }
    };

    const searchIcon = (
        <Fragment>
            <Search20Svg className="indicator__icon" />
            <Cross20Svg className="indicator__icon indicator__icon--open" />
        </Fragment>
    );

    const searchDropdown = (
        <Search context="indicator" inputRef={inputRef} onClose={handleClose} />
    );

    return (
        <Indicator
            ref={indicatorRef}
            dropdown={searchDropdown}
            icon={searchIcon}
            onOpen={handleOpen}
        />
    );
}

export default IndicatorSearch;
