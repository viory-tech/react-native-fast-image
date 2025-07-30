import React from 'react';
import {PixelRatio, StyleSheet, Text, View} from 'react-native';
import FastImage from 'react-native-fast-image';
import Section from './Section';
import SectionFlex from './SectionFlex';
import FeatureText from './FeatureText';
import {useCacheBust} from './useCacheBust';

const getImageUrl = (id: string, width: number, height: number) =>
  `https://unsplash.it/${width}/${height}?image=${id}`;
const IMAGE_SIZE = 1024;
const IMAGE_SIZE_PX = PixelRatio.getPixelSizeForLayoutSize(IMAGE_SIZE);
const IMAGE_URLS = [
  getImageUrl('0', IMAGE_SIZE_PX, IMAGE_SIZE_PX),
  getImageUrl('1', IMAGE_SIZE_PX, IMAGE_SIZE_PX),
  getImageUrl('2', IMAGE_SIZE_PX, IMAGE_SIZE_PX),
];

export const PriorityExample = () => {
  const {query, bust} = useCacheBust('');
  return (
    <View>
      <Section>
        <FeatureText text="• Prioritize images (low, normal, high)." />
      </Section>
      <SectionFlex onPress={bust}>
        <FastImage
          style={styles.image}
          source={{
            uri: IMAGE_URLS[0] + query.replace('?', '&'),
            priority: FastImage.priority.low,
          }}
        />
        <FastImage
          style={styles.image}
          source={{
            uri: IMAGE_URLS[1] + query.replace('?', '&'),
            priority: FastImage.priority.normal,
          }}
        />
        <FastImage
          style={styles.image}
          source={{
            uri: IMAGE_URLS[2] + query.replace('?', '&'),
            priority: FastImage.priority.high,
          }}
        />
      </SectionFlex>
      <Section>
        <FeatureText text="• Cache tier (primary, secondary)." />
      </Section>
      <SectionFlex onPress={bust}>
        <FastImage
          style={styles.image}
          source={{
            // uri: IMAGE_URLS[0] + query.replace('?', '&'),
            uri: 'https://plus.unsplash.com/premium_photo-1683910767532-3a25b821f7ae?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZnJlZSUyMGltYWdlc3xlbnwwfHwwfHx8MA%3D%3D',
            cacheTier: 'primary',
          }}
        />
        <FastImage
          style={styles.image}
          source={{
            // uri: IMAGE_URLS[1] + query.replace('?', '&'),
            uri: 'https://images.unsplash.com/photo-1626808642875-0aa545482dfb?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJlZSUyMGltYWdlc3xlbnwwfHwwfHx8MA%3D%3D',
            cacheTier: 'secondary',
          }}
        />
      </SectionFlex>
    </View>
  );
};

const styles = StyleSheet.create({
  image: {
    flex: 1,
    height: 100,
    backgroundColor: '#ddd',
    margin: 10,
    marginVertical: 20,
  },
});
