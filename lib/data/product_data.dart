import '../screens/product_listing_screen.dart';

class ProductRepository {
  static final Map<String, List<Product>> componentData = {
    'Processor': [
      Product(name: 'AMD Ryzen 9 7950X', specs: '16 Cores, 5.7GHz', rating: 4.9, price: 549.99, imageUrl: 'assets/images/cpu_ryzen.png'),
      Product(name: 'Intel Core i9-14900K', specs: '24 Cores, 6.0GHz', rating: 4.8, price: 589.00, imageUrl: 'assets/images/cpu_intel.png'),
    ],
    'GPU': [
      Product(name: 'NVIDIA RTX 4090', specs: '24GB GDDR6X', rating: 5.0, price: 1599.99, imageUrl: 'assets/images/gpu_4090.png'),
      Product(name: 'AMD Radeon RX 7900 XTX', specs: '24GB GDDR6', rating: 4.7, price: 949.00, imageUrl: 'assets/images/gpu_7900.png'),
    ],
    'Motherboard': [
      Product(name: 'ASUS ROG Z790', specs: 'DDR5, Wi-Fi 7', rating: 4.7, price: 629.99, imageUrl: 'assets/images/mobo_asus.png'),
      Product(name: 'MSI MAG B650', specs: 'DDR5, Wi-Fi 6E', rating: 4.6, price: 219.00, imageUrl: 'assets/images/mobo_msi.png'),
    ],
    'RAM': [
      Product(name: 'Corsair 32GB DDR5', specs: '6000MHz, CL30', rating: 4.8, price: 124.99, imageUrl: 'assets/images/ram_corsair.png'),
      Product(name: 'G.Skill 32GB DDR5', specs: '6400MHz, CL32', rating: 4.9, price: 139.99, imageUrl: 'assets/images/ram_gskill.png'),
    ],
    'Storage': [
      Product(name: 'Samsung 990 Pro 2TB', specs: 'NVMe Gen4', rating: 4.9, price: 179.99, imageUrl: 'assets/images/ssd_samsung.png'),
      Product(name: 'Crucial P3 Plus 1TB', specs: 'NVMe Gen4', rating: 4.5, price: 69.99, imageUrl: 'assets/images/ssd_crucial.png'),
    ],
    'Cooling': [
      Product(name: 'NZXT Kraken 360', specs: 'AIO, LCD Display', rating: 4.8, price: 279.99, imageUrl: 'assets/images/cooler_nzxt.png'),
      Product(name: 'Noctua NH-D15', specs: 'Dual-Tower Air', rating: 4.9, price: 119.95, imageUrl: 'assets/images/cooler_noctua.png'),
    ],
    'PSU': [
      Product(name: 'Corsair RM1000x', specs: '1000W Gold', rating: 4.8, price: 189.99, imageUrl: 'assets/images/psu_corsair.png'),
      Product(name: 'EVGA SuperNOVA 850G', specs: '850W Gold', rating: 4.7, price: 129.99, imageUrl: 'assets/images/psu_evga.png'),
    ],
    'Case': [
      Product(name: 'Lian Li PC-O11', specs: 'Mid-Tower, Glass', rating: 4.9, price: 149.99, imageUrl: 'assets/images/case_lianli.png'),
      Product(name: 'Corsair 4000D', specs: 'Mid-Tower, Airflow', rating: 4.7, price: 104.99, imageUrl: 'assets/images/case_corsair.png'),
    ],
  };
}