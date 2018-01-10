import React from 'react';
import expect from 'expect';
import { mount } from 'enzyme';

import App from 'components/App';
import connectWrapper from 'test/connect_wrapper';

describe('App - component', () => {
  it('renders', () => {
    const WrappedApp = connectWrapper(App);
    const Component = mount(<WrappedApp />);

    expect(Component.find('App').length).toEqual(1);
  });
});
